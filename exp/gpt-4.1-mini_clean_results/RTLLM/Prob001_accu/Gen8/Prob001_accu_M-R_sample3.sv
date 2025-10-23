module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    typedef enum logic [1:0] {ACCUMULATE=2'd0, OUTPUT=2'd1} state_t;
    state_t state, next_state;

    reg [9:0] accumulator;
    reg [1:0] count;

    // Next state and output logic
    always @(*) begin
        valid_out = 1'b0;
        data_out  = 10'd0;
        next_state = state;
        case (state)
            ACCUMULATE: begin
                if (count == 2'd4)
                    next_state = OUTPUT;
            end
            OUTPUT: begin
                valid_out = 1'b1;
                data_out  = accumulator;
                next_state = ACCUMULATE;
            end
        endcase
    end

    // Sequential state, accumulator, and count updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= ACCUMULATE;
            accumulator <= 10'd0;
            count       <= 2'd0;
        end else begin
            state <= next_state;

            case (state)
                ACCUMULATE: begin
                    if (valid_in) begin
                        accumulator <= accumulator + data_in;
                        count <= count + 1'b1;
                    end
                end
                OUTPUT: begin
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
            endcase
        end
    end

endmodule