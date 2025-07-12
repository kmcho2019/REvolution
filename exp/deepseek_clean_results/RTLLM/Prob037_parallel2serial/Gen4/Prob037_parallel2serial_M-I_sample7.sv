module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // One-hot state encoding (4 states)
    reg [3:0] state;
    reg [3:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;  // Start at state 0
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            case (state)
                4'b0001: begin // State 0 (first bit)
                    data_reg <= d;
                    dout <= d[3];
                    valid_out <= 1'b1;
                    state <= 4'b0010;
                end
                4'b0010: begin // State 1 (second bit)
                    dout <= data_reg[2];
                    valid_out <= 1'b0;
                    state <= 4'b0100;
                end
                4'b0100: begin // State 2 (third bit)
                    dout <= data_reg[1];
                    valid_out <= 1'b0;
                    state <= 4'b1000;
                end
                4'b1000: begin // State 3 (fourth bit)
                    dout <= data_reg[0];
                    valid_out <= 1'b0;
                    state <= 4'b0001;
                end
                default: begin
                    state <= 4'b0001;
                end
            endcase
        end
    end

endmodule