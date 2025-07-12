module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b0;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            case (state)
                3'b000: state <= (data) ? 3'b001 : 3'b000;  // First '1'
                3'b001: state <= (data) ? 3'b010 : 3'b000;  // Second '1'
                3'b010: state <= (data) ? 3'b010 : 3'b011;  // '0' after '11'
                3'b011: state <= (data) ? 3'b100 : 3'b000;  // Final '1'
                default: state <= 3'b0;
            endcase
            start_shifting <= (state == 3'b011 && data);
        end
    end

endmodule