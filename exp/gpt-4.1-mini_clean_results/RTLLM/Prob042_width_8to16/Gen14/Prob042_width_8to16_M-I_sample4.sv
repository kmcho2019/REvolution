module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM States
    localparam IDLE  = 1'b0; // waiting for first byte
    localparam WAIT2 = 1'b1; // waiting for second byte

    reg state;
    reg [7:0] first_byte;

    // Registers for output staging
    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            first_byte  <= 8'd0;
            data_out    <= 16'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        first_byte <= data_in;
                        state      <= WAIT2;
                    end
                    // no output valid here
                    valid_out_next <= 1'b0;
                    data_out_next  <= 16'd0;
                end
                WAIT2: begin
                    if (valid_in) begin
                        // On second byte input, prepare output for next cycle
                        data_out_next  <= {first_byte, data_in};
                        valid_out_next <= 1'b1;
                        state          <= IDLE;
                    end else begin
                        // No input, keep outputs invalid
                        valid_out_next <= 1'b0;
                        data_out_next  <= data_out; // hold previous output
                    end
                end
            endcase
        end
    end

endmodule