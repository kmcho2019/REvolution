module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding (2 bits)
    // S0: no match
    // S1: matched '1'
    // S2: matched "11"
    // S3: matched "110"
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            case (state)
                2'b00: state <= data ? 2'b01 : 2'b00;
                2'b01: state <= data ? 2'b10 : 2'b00;
                2'b10: state <= data ? 2'b10 : 2'b11;
                2'b11: begin
                    if (data) begin
                        start_shifting <= 1'b1;
                        // State can be held or reset here; it won't matter as start_shifting is latched
                        state <= 2'b11;
                    end else
                        state <= 2'b00;
                end
                default: state <= 2'b00;
            endcase
        end
    end

endmodule