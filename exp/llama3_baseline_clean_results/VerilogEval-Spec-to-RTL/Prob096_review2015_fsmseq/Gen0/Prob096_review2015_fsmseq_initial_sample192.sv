module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// Enumerate states for better readability
typedef enum logic [2:0] {
    Idle = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    Found = 3'b100
} states;

// Declare current and next states
states current_state, next_state;

// Output logic
logic start_shifting_reg;

// Combinational logic for next state and output
always_comb begin
    case (current_state)
        Idle: begin
            if (data) begin
                next_state = S1;
            end else begin
                next_state = Idle;
            end
        end
        S1: begin
            if (data) begin
                next_state = S2;
            end else begin
                next_state = Idle;
            end
        end
        S2: begin
            if (!data) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data) begin
                next_state = Found;
            end else begin
                next_state = Idle;
            end
        end
        Found: begin
            next_state = Found;
        end
    endcase
    
    // Output logic
    if (current_state == Found) begin
        start_shifting_reg = 1'b1;
    end else begin
        start_shifting_reg = 1'b0;
    end
end

// Sequential logic for state register and output register
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= Idle;
        start_shifting <= 1'b0;
    end else begin
        current_state <= next_state;
        start_shifting <= start_shifting_reg;
    end
end

endmodule