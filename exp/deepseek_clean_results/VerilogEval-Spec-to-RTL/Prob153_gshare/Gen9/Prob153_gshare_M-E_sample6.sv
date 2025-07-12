module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Segmented GHR: [3-bit recent][4-bit older]
    reg [2:0] ghr_recent;
    reg [3:0] ghr_older;
    wire [6:0] ghr = {ghr_recent, ghr_older};
    
    // History recovery stack (2 entries)
    reg [6:0] recovery_stack [0:1];
    reg stack_ptr;
    
    // PHT with shadow entries (128 main + 8 shadow)
    reg [1:0] pht [0:135];
    reg [6:0] shadow_map [0:7]; // Maps shadow entries to main indices
    
    // Prediction path
    wire [2:0] pc_lsb = predict_pc[2:0];
    wire [3:0] pc_msb = predict_pc[6:3];
    wire [6:0] predict_index = {pc_msb ^ ghr_older, pc_lsb ^ ghr_recent};
    
    // Shadow entry lookup
    wire [2:0] shadow_hit;
    wire shadow_match = |shadow_hit;
    wire [6:0] actual_index = shadow_match ? {4'b0, shadow_hit} + 128 : predict_index;
    
    assign predict_taken = pht[actual_index][1];
    assign predict_history = ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    wire [2:0] train_shadow_hit;
    wire train_shadow_match = |train_shadow_hit;
    wire [6:0] train_actual_index = train_shadow_match ? {4'b0, train_shadow_hit} + 128 : train_index;
    
    // Counter update function (optimized)
    function [1:0] update_counter(input [1:0] current, input taken);
        update_counter = taken ? (current + (current != 2'b11)) : 
                                (current - (current != 2'b00));
    endfunction
    
    // Shadow entry management
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_recent <= 3'b0;
            ghr_older <= 4'b0;
            stack_ptr <= 0;
            
            for (integer i = 0; i < 128; i++)
                pht[i] <= 2'b01;
            for (integer i = 0; i < 8; i++)
                shadow_map[i] <= 7'b0;
        end else begin
            // Handle misprediction recovery
            if (train_valid && train_mispredicted) begin
                {ghr_recent, ghr_older} <= recovery_stack[stack_ptr];
                stack_ptr <= stack_ptr - 1;
            end
            // Normal GHR update
            else if (predict_valid) begin
                ghr_recent <= {ghr_recent[1:0], predict_taken};
                ghr_older <= {ghr_older[2:0], ghr_recent[2]};
                
                // Push to recovery stack if needed
                if (train_valid && !train_mispredicted) begin
                    recovery_stack[stack_ptr+1] <= {ghr_recent[1:0], predict_taken, ghr_older};
                    stack_ptr <= stack_ptr + 1;
                end
            end
            
            // PHT updates
            if (predict_valid) begin
                // Speculative update (weaken current prediction)
                pht[actual_index] <= update_counter(pht[actual_index], predict_taken);
                
                // Allocate shadow entry if needed
                if (!shadow_match && (predict_index == train_index) begin
                    for (integer i = 0; i < 8; i++) begin
                        if (shadow_map[i] == 0) begin
                            shadow_map[i] <= predict_index;
                            pht[128+i] <= pht[predict_index];
                            break;
                        end
                    end
                end
            end
            
            if (train_valid) begin
                // Update main or shadow PHT
                pht[train_actual_index] <= update_counter(pht[train_actual_index], train_taken);
                
                // Release shadow entry if no longer needed
                if (train_shadow_match && (train_index != predict_index)) begin
                    shadow_map[train_shadow_hit] <= 0;
                end
            end
        end
    end
    
    // Shadow hit detection (combinational)
    always @(*) begin
        shadow_hit = 0;
        for (integer i = 0; i < 8; i++) begin
            if (shadow_map[i] == predict_index)
                shadow_hit = i[2:0];
        end
        
        train_shadow_hit = 0;
        for (integer i = 0; i < 8; i++) begin
            if (shadow_map[i] == train_index)
                train_shadow_hit = i[2:0];
        end
    end

endmodule