module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Primary instruction registers
    reg [7:0] ins_p1;    // Current instruction
    reg [7:0] ins_p2;    // Secondary source
    reg [7:0] ins_p3;    // Prefetch buffer
    
    // Internal signals for early decoding
    wire [2:0] next_ins;
    wire [4:0] next_ad1;
    
    // Early field separation during fetch
    assign next_ins = data[7:5];
    assign next_ad1 = data[4:0];
    
    // Gated clock enable for prefetch buffer
    wire prefetch_en = (fetch == 2'b01) && (ins_p3 != data);
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
            ins_p3 <= 8'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            // Main instruction update
            case (fetch)
                2'b01: begin
                    ins_p1 <= ins_p3;    // Use prefetched instruction
                    ins_p3 <= data;     // Prefetch next
                end
                2'b10: ins_p2 <= data;
                default: ;              // Hold state
            endcase
            
            // Buffered outputs (improves timing)
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            ad2 <= ins_p2;
        end
    end
    
    // Prefetch buffer update (gated clock domain)
    always @(posedge clk) begin
        if (prefetch_en) begin
            ins_p3 <= data;
        end
    end

endmodule