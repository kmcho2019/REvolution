module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// Continuous assignment for output g
assign g = (current_state == B) ? 3'b100 :
            (current_state == C) ? 3'b010 :
            3'b000;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = C; // go to C for r[2] as D is not used
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
        default: next_state = A;
    endcase
end

endmodule