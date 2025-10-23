module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    localparam IDLE       = 1'b0;
    localparam ACCUMULATE = 1'b1;

    reg state, next_state;
    reg [1:0] count, next_count;
    reg [9:0] accumulator, next_accumulator;

    // FSM sequential block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            count       <= 2'd0;
            accumulator <= 10'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            state       <= next_state;
            count       <= next_count;
            accumulator <= next_accumulator;
            valid_out   <= 1'b0;  // default low
            data_out    <= data_out; // default hold
        end
    end

    // FSM combinational logic
    always @(*) begin
        // Defaults
        next_state       = state;
        next_count       = count;
        next_accumulator = accumulator;

        case (state)
            IDLE: begin
                if (valid_in) begin
                    next_state       = ACCUMULATE;
                    next_count       = 2'd1;
                    next_accumulator = data_in;
                end
            end

            ACCUMULATE: begin
                if (valid_in) begin
                    if (count == 2'd3) begin
                        // Output the sum after 4 inputs
                        next_state       = IDLE;
                        next_count       = 2'd0;
                        next_accumulator = 10'd0;
                    end else begin
                        next_count       = count + 1'b1;
                        next_accumulator = accumulator + data_in;
                    end
                end
            end
        endcase
    end

    // Output valid and data_out generation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            if (state == ACCUMULATE && valid_in && count == 2'd3) begin
                // When 4th valid input received, output sum
                data_out  <= accumulator + data_in;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule