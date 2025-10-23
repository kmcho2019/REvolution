module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // State encoding
    localparam IDLE   = 2'd0;
    localparam ACCUM  = 2'd1;
    localparam OUTPUT = 2'd2;

    reg [1:0] state, next_state;
    reg [9:0] accumulator;
    reg [1:0] count;

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    valid_out   <= 1'b0;
                    if (valid_in) begin
                        accumulator <= data_in;
                        count       <= 2'd1;
                    end
                end
                ACCUM: begin
                    valid_out <= 1'b0;
                    if (valid_in) begin
                        accumulator <= accumulator + data_in;
                        count       <= count + 1'b1;
                    end
                end
                OUTPUT: begin
                    valid_out <= 1'b1;
                    data_out  <= accumulator;
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end
                default: begin
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = (count == 2'd4 || count == 2'd1) ? ACCUM : IDLE;
                else
                    next_state = IDLE;
            end
            ACCUM: begin
                // Move to OUTPUT when count reaches 4
                if (count == 2'd4)
                    next_state = OUTPUT;
                else
                    next_state = ACCUM;
            end
            OUTPUT: begin
                // After output, go to IDLE to await next batch
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule