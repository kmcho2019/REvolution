module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare current state and next state signals
reg [1:0] current_state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table logic
always @(*) begin
    case (current_state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else if (r[1] == 1'b1) begin
                next_state <= C;
            end else if (r[2] == 1'b1) begin
                next_state <= D;
            end else begin
                next_state <= A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                next_state <= C;
            end else begin
                next_state <= A;
            end
        end
        D: begin
            // Since device 2 has the lowest priority, it will only receive a grant if it is the only device making a request.
            // However, if device 0 or 1 makes a request, the FSM should grant access to that device instead.
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else if (r[1] == 1'b1) begin
                next_state <= C;
            end else if (r[2] == 1'b1) begin
                next_state <= D;
            end else begin
                next_state <= A;
            end
        end
        default: next_state <= A;
    endcase
end

// Output logic
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = (current_state == D);

endmodule