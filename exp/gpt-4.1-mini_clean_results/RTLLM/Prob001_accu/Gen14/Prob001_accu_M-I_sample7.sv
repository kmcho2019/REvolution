module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // States for accumulation process
    localparam IDLE = 1'b0;
    localparam ACCU = 1'b1;

    reg state;
    reg [9:0] accumulator;
    reg [1:0] count;

    // Signals
    wire acc_enable = valid_in && (state == IDLE || state == ACCU);

    wire [9:0] acc_next = accumulator + data_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no valid output

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        accumulator <= data_in; // initialize accumulator
                        count       <= 2'd1;
                        state       <= ACCU;
                    end
                end

                ACCU: begin
                    if (valid_in) begin
                        if (count == 2'd3) begin
                            // Last data in batch
                            data_out    <= acc_next;
                            valid_out   <= 1'b1;
                            accumulator <= 10'd0;
                            count       <= 2'd0;
                            state       <= IDLE;
                        end else begin
                            accumulator <= acc_next;
                            count       <= count + 1'b1;
                        end
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule