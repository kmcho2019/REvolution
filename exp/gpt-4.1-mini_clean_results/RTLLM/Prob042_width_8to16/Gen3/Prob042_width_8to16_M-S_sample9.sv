module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM states
    localparam WAIT_FIRST  = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state;
    reg [7:0] data_lock;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= WAIT_FIRST;
            data_lock <= 8'd0;
            data_out  <= 16'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0; // Default deassert valid_out

            case (state)
                WAIT_FIRST: begin
                    if (valid_in) begin
                        data_lock <= data_in;
                        state     <= WAIT_SECOND;
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        data_out  <= {data_lock, data_in};
                        valid_out <= 1'b1;
                        state     <= WAIT_FIRST;
                    end
                end
            endcase
        end
    end

endmodule