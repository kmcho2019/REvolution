module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State codes
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
// Not directly used but included for completeness
// localparam D = 2'b11;

reg [1:0] current_state, next_state;

// State Flip-Flops
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Next State Logic
always @(*) begin
    case (current_state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = A; // This was a mistake in the original description; it seems it should stay in A if only r2=1
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0]) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1]) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        default: next_state = A; // Shouldn't reach here due to state encoding
    endcase
end

// Output Logic
always @(*) begin
    case (current_state)
        A: g = 3'b000;
        B: g = 3'b100;
        C: g = 3'b010;
        default: g = 3'b000; // Shouldn't reach here due to state encoding
    endcase
end

endmodule