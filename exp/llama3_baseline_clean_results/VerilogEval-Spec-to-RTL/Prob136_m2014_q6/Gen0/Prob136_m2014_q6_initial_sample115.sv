module TopModule(
    input         clk,
    input         reset,
    input         w,
    output        z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Declare the current state and next state
reg [2:0] current_state;
reg [2:0] next_state;

// Assign the output z based on the current state
assign z = (current_state == E) || (current_state == F);

// Always block for sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // If reset is high, go to state A
        current_state <= A;
    end else begin
        // Update the current state
        current_state <= next_state;
    end
end

// Always block for combinational logic
always @(*) begin
    case (current_state)
        A: begin
            if (w) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        C: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        D: begin
            if (w) begin
                next_state = A;
            end else begin
                next_state = F;
            end
        end
        E: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        F: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        default: begin
            next_state = A;
        end
    endcase
end

endmodule