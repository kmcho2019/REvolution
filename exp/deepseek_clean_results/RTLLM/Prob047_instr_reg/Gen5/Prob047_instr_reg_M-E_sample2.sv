module instr_reg (
    input clk,
    input rst_n,  // Active low reset (synchronous)
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    parameter WIDTH = 8;
    reg [WIDTH-1:0] reg_file [0:1];  // Unified register file
    reg valid [0:1];  // Validity flags

    // Write control logic
    always @(posedge clk) begin
        if (!rst_n) begin
            reg_file[0] <= 0;
            reg_file[1] <= 0;
            valid[0] <= 0;
            valid[1] <= 0;
            ins <= 0;
            ad1 <= 0;
            ad2 <= 0;
        end else begin
            // Write operations with validity tracking
            case (fetch)
                2'b01: begin
                    reg_file[0] <= data;
                    valid[0] <= 1;
                end
                2'b10: begin
                    reg_file[1] <= data;
                    valid[1] <= 1;
                end
                default: ; // Maintain current values
            endcase

            // Pipelined output registers (improves timing)
            if (valid[0]) {ins, ad1} <= reg_file[0];
            if (valid[1]) ad2 <= reg_file[1];
        end
    end

endmodule