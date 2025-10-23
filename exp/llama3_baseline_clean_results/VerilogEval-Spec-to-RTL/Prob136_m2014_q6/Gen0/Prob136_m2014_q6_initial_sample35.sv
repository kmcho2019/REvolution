module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state, next_state;

// Encode states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Determine next state
always @(*) begin
    case (current_state)
        A: begin
            if (~w)
                next_state = B;
            else
                next_state = A;
        end
        B: begin
            if (~w)
                next_state = C;
            else
                next_state = D;
        end
        C: begin
            if (~w)
                next_state = E;
            else
                next_state = D;
        end
        D: begin
            if (~w)
                next_state = F;
            else
                next_state = A;
        end
        E: begin
            if (~w)
                next_state = E;
            else
                next_state = D;
        end
        F: begin
            if (~w)
                next_state = C;
            else
                next_state = D;
        end
        default: next_state = A; // In case of invalid state
    endcase
end

// Update current state
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Determine output z
assign z = (current_state == E || current_state == F);

endmodule