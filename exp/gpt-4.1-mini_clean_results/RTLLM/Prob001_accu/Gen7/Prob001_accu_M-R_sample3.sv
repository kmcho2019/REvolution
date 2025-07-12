module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        ACCUM = 2'b01
    } state_t;

    state_t current_state, next_state;
    reg [9:0] accumulator;
    reg [2:0] count;  // count up to 4

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Sequential logic: accumulator and count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 3'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default deassert
            case (current_state)
                IDLE: begin
                    if (valid_in) begin
                        accumulator <= data_in;
                        count <= 3'd1;
                    end else begin
                        accumulator <= 10'd0;
                        count <= 3'd0;
                    end
                end
                ACCUM: begin
                    if (valid_in) begin
                        accumulator <= accumulator + data_in;
                        count <= count + 3'd1;
                        if (count == 3'd3) begin
                            // 4th data_in
                            data_out <= accumulator + data_in;
                            valid_out <= 1'b1;
                            accumulator <= 10'd0;
                            count <= 3'd0;
                        end
                    end
                end
                default: begin
                    accumulator <= 10'd0;
                    count <= 3'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (valid_in)
                    next_state = ACCUM;
            end
            ACCUM: begin
                if (valid_in && count == 3'd3)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule