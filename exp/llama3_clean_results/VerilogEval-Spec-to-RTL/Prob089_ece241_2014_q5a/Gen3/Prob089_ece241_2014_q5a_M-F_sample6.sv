module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

// Define the states
enum logic [1:0] {IDLE, ACTIVE, DONE} state;

reg [7:0] accumulator; // Assuming 8-bit numbers for simplicity
reg [7:0] result;
reg started;

// State machine
always @ (posedge clk or posedge areset) begin
    if(areset) begin
        state <= IDLE;
        started <= 1'b0;
        accumulator <= 8'b0;
        result <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                if(x) begin
                    state <= ACTIVE;
                    started <= 1'b1;
                    accumulator <= {7'b0, x};
                end
            end
            ACTIVE: begin
                accumulator <= {accumulator[6:0], x};
                if(areset) begin // Stop accumulation when reset is asserted
                    state <= DONE;
                end
            end
            DONE: begin
                // Calculate 2's complement
                result <= ~accumulator + 1'b1;
                state <= IDLE; // Return to idle state
            end
            default: begin
                state <= IDLE;
                started <= 1'b0;
                accumulator <= 8'b0;
                result <= 8'b0;
            end
        endcase
    end
end

// Output logic
always @ (*) begin
    if(state == DONE) begin
        z = result[0]; // Output the least significant bit of the result
    end else begin
        z = 1'b0; // Default output when not in DONE state
    end
end

endmodule