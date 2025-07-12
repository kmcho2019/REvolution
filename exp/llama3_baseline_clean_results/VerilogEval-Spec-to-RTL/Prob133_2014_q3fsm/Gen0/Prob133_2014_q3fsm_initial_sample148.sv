module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// Define the states
enum logic [1:0] {A, B, C} state, next_state;

// Define a counter to count w = 1 in three cycles
logic [1:0] counter;

// Define a flag to indicate if we are checking w
logic checking;

// Define a signal to store the output z
logic z_next;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
        counter <= 0;
        checking <= 0;
        z <= 0;
    end else begin
        state <= next_state;
        counter <= counter + (checking && w);
        checking <= checking + (state == B && s);
        if (checking && counter == 2 && state == C) begin
            z <= 1;
        end else if (checking && (counter != 2 || state != C)) begin
            z <= 0;
        end
    end
end

// Combinational logic
always_comb begin
    case (state)
        A: begin
            if (s) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            next_state = C;
        end
        C: begin
            if (counter == 2) begin
                next_state = B;
            end else begin
                next_state = C;
            end
            if (counter == 3) begin
                counter = 0;
            end
        end
    endcase
end

endmodule