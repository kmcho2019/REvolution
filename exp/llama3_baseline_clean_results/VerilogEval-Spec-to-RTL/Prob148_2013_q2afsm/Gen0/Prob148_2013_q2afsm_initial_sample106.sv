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

// State register
reg [1:0] state;
reg [1:0] next_state;

// Next state logic
always @(*)
begin
    case(state)
        A:
            if (r[0] == 1'b1) begin
                next_state = B;
            end
            else if (r[1] == 1'b1) begin
                next_state = C;
            end
            else if (r[2] == 1'b1) begin
                next_state = D;
            end
            else begin
                next_state = A;
            end
        B:
            if (r[0] == 1'b1) begin
                next_state = B;
            end
            else begin
                next_state = A;
            end
        C:
            if (r[1] == 1'b1) begin
                next_state = C;
            end
            else begin
                next_state = A;
            end
        D:
            if (r[2] == 1'b1) begin
                next_state = D;
            end
            else begin
                next_state = A;
            end
        default:
            next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (~resetn) begin
        state <= A;
    end
    else begin
        state <= next_state;
    end
end

// Output logic
assign g[0] = (state == B) ? 1'b1 : 1'b0;
assign g[1] = (state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Device 2 will not receive a grant in this implementation

endmodule