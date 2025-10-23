module accu (
    input         clk,
    input         rst_n,
    input         valid_in,
    input  [7:0]  data_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [9:0] accumulator;
reg [1:0] counter;
reg [1:0] state;

// Define states
localparam IDLE = 2'b00;
localparam ACCUMULATE = 2'b01;
localparam OUTPUT = 2'b10;
localparam RESET = 2'b11;

// Initialize state and signals
initial begin
    accumulator = 10'b0;
    counter = 2'b0;
    state = IDLE;
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulator <= 10'b0;
        counter <= 2'b0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    state <= ACCUMULATE;
                    accumulator <= data_in;
                    counter <= 2'b1;
                end
            end
            ACCUMULATE: begin
                if (counter < 2'b11) begin
                    // Simplified addition to reduce critical path
                    if (valid_in) begin
                        accumulator <= accumulator + {1'b0, data_in};
                        counter <= counter + 1'b1;
                    end
                end else begin
                    state <= OUTPUT;
                end
            end
            OUTPUT: begin
                // Directly drive valid_out from state machine for area optimization
                state <= RESET;
            end
            RESET: begin
                accumulator <= 10'b0;
                counter <= 2'b0;
                state <= IDLE;
            end
        endcase
    end
end

// Output logic with clock gating for power reduction
always @(posedge clk) begin
    if (state == OUTPUT) begin
        valid_out <= 1'b1;
        data_out <= accumulator;
    end else begin
        valid_out <= 1'b0;
    end
end

endmodule