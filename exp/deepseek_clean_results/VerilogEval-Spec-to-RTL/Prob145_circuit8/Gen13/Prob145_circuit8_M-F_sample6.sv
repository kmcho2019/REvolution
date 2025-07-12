module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

// Synchronous behavior
always @(posedge clock) begin
    case (state)
        2'b00: begin  // Initial state
            p <= a;
            q <= 0;
            state <= a ? 2'b01 : 2'b00;
        end
        2'b01: begin  // p was 1 last cycle
            p <= a;
            q <= 1;
            state <= a ? 2'b01 : 2'b10;
        end
        2'b10: begin  // q is 1
            p <= 0;
            q <= 1;
            state <= 2'b10;
        end
        default: begin
            p <= 0;
            q <= 0;
            state <= 2'b00;
        end
    endcase
end

// Asynchronous reset of q when a=1 during clock low and in state 01 or 10
always @(a or clock) begin
    if (a && ~clock && (state == 2'b01 || state == 2'b10)) begin
        q <= 0;
        state <= 2'b00;
    end
end

initial begin
    p = 0;
    q = 0;
    state = 2'b00;
end

endmodule