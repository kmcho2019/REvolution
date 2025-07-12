module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;
    reg output_valid;

    // Register update on rising edge
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p2 <= 0;
            output_valid <= 0;
        end else begin
            // Priority encoded fetch handling
            case (fetch)
                2'b01: ins_p1 <= data;
                2'b10: ins_p2 <= data;
                default: begin
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
            output_valid <= |fetch;  // Output only updates when fetch is active
        end
    end

    // Output update on falling edge with isolation
    always @(negedge clk) begin
        if (output_valid) begin
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            ad2 <= ins_p2;
        end
        // Else outputs retain previous values (implicit)
    end

endmodule