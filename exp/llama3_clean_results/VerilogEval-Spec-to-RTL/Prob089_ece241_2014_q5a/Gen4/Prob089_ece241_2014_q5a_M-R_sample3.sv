module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

// Define the states
enum logic [1:0] {IDLE, ACTIVE} state;

reg [7:0] accumulator; // Assuming 8-bit numbers for simplicity
reg [7:0] result;
reg [2:0] counter; // Counter to keep track of the number of bits accumulated
reg started;

// State machine
always @ (posedge clk or posedge areset) begin
    if(areset) begin
        state <= IDLE;
        started <= 1'b0;
        accumulator <= 8'b0;
        counter <= 3'b0;
    end else begin
        case (state)
            IDLE: begin
                if(x) begin
                    state <= ACTIVE;
                    started <= 1'b1;
                    accumulator <= {7'b0, x};
                    counter <= 3'b1;
                end
            end
            ACTIVE: begin
                accumulator <= {accumulator[6:0], x};
                counter <= counter + 1'b1;
            end
            default: begin
                state <= IDLE;
                started <= 1'b0;
                accumulator <= 8'b0;
                counter <= 3'b0;
            end
        endcase
    end
end

// Output logic
assign z = (state == ACTIVE && counter == 3'b0) ? (~accumulator[0] + 1'b1) : 1'b0;

// Asynchronous reset
always @ (posedge areset) begin
    state <= IDLE;
    started <= 1'b0;
    accumulator <= 8'b0;
    counter <= 3'b0;
end

endmodule