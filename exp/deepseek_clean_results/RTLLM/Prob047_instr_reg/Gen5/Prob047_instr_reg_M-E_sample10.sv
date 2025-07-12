module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Pipeline stage registers
    reg [7:0] fetch_stage;
    reg [7:0] decode_stage;
    
    // Shadow registers for power optimization
    reg [7:0] shadow_p1;
    reg [7:0] shadow_p2;
    
    // Control signals
    wire fetch_valid = (fetch == 2'b01) || (fetch == 2'b10);
    wire decode_ready = (fetch == 2'b01) || (fetch == 2'b10);
    
    // Dynamic clock enables
    wire fetch_en = fetch_valid;
    wire decode_en = decode_ready;
    wire shadow_update = (fetch == 2'b01) || (fetch == 2'b10);

    // Pipeline stage 1: Instruction Fetch
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            fetch_stage <= 8'b0;
            shadow_p1 <= 8'b0;
            shadow_p2 <= 8'b0;
        end
        else if (fetch_en) begin
            case (fetch)
                2'b01: begin
                    fetch_stage <= data;
                    shadow_p1 <= data;  // Update shadow register
                end
                2'b10: begin
                    fetch_stage <= data;
                    shadow_p2 <= data;  // Update shadow register
                end
            endcase
        end
    end

    // Pipeline stage 2: Instruction Decode
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            decode_stage <= 8'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else if (decode_en) begin
            decode_stage <= fetch_stage;
            
            // Output generation with shadow register fallback
            ins <= (fetch == 2'b01) ? fetch_stage[7:5] : shadow_p1[7:5];
            ad1 <= (fetch == 2'b01) ? fetch_stage[4:0] : shadow_p1[4:0];
            ad2 <= (fetch == 2'b10) ? fetch_stage : shadow_p2;
        end
    end

endmodule