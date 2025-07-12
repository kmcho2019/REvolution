module TopModule (
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

// Current state register
reg [1:0] state;
reg [1:0] next_state;

// State flip-flop
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
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
        D: begin
            // Assuming D returns to A when its request is deasserted
            if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        default: begin
            next_state = A;
        end
    endcase
end

// Output logic
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = (state == D);

endmodule