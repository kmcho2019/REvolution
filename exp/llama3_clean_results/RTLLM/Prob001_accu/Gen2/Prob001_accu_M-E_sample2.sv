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
reg        valid_out_reg;

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
    valid_out_reg = 1'b0;
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulator <= 10'b0;
        counter <= 2'b0;
        state <= IDLE;
        valid_out_reg <= 1'b0;
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
                    accumulator <= accumulator + data_in;
                    counter <= counter + 1'b1;
                end else begin
                    state <= OUTPUT;
                end
            end
            OUTPUT: begin
                valid_out_reg <= 1'b1;
                state <= RESET;
            end
            RESET: begin
                accumulator <= 10'b0;
                counter <= 2'b0;
                state <= IDLE;
                valid_out_reg <= 1'b0;
            end
        endcase
    end
end

// Output logic
assign valid_out = valid_out_reg;
assign data_out = accumulator;

endmodule