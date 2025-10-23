module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    // FSM states
    localparam IDLE       = 1'b0;
    localparam ACCUMULATE = 1'b1;

    reg state, next_state;
    reg [1:0] count, next_count;
    reg [9:0] sum, next_sum;

    // Next sum and count logic
    wire accumulate_en = valid_in && (state == ACCUMULATE);

    assign next_sum = accumulate_en ? (sum + data_in) : ( (state == IDLE && valid_in) ? data_in : sum );
    assign next_count = accumulate_en ? (count + 1'b1) : ( (state == IDLE && valid_in) ? 2'd1 : count );

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = valid_in ? ACCUMULATE : IDLE;
            ACCUMULATE: next_state = (count == 2'd3 && valid_in) ? IDLE : ACCUMULATE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            sum       <= 10'd0;
            count     <= 2'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            sum   <= next_sum;
            count <= next_count;

            // Output logic
            if (state == ACCUMULATE && count == 2'd3 && valid_in) begin
                data_out  <= next_sum; // sum + data_in
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule