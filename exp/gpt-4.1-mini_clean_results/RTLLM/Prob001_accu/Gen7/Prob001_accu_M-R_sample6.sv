module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // State encoding
    typedef enum logic [0:0] {ACCUM=1'b0, OUTPUT=1'b1} state_t;
    state_t state, next_state;

    reg [9:0] accumulator;
    reg [1:0] count;
    wire [9:0] next_accumulator = accumulator + data_in;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= ACCUM;
        else
            state <= next_state;
    end

    // Output and next state logic
    always @(*) begin
        next_state = state;
        valid_out = 1'b0;
        data_out = 10'd0;
        case (state)
            ACCUM: begin
                if (valid_in && count == 2'd3)
                    next_state = OUTPUT;
            end
            OUTPUT: begin
                valid_out = 1'b1;
                next_state = ACCUM;
            end
        endcase
    end

    // Accumulator and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count <= 2'd0;
        end else begin
            case (state)
                ACCUM: begin
                    if (valid_in) begin
                        accumulator <= next_accumulator;
                        count <= count + 1'b1;
                    end
                end
                OUTPUT: begin
                    data_out <= accumulator;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
            endcase
        end
    end

endmodule