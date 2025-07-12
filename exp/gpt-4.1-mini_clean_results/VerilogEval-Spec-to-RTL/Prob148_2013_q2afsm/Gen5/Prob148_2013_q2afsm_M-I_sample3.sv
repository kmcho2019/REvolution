module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

// State encoding (binary)
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] state, next_state;

// Next state logic and output combinational block
always @(*) begin
    // Default assignments
    next_state = state;
    g = 3'b000;

    case (state)
        A: begin
            // Priority encoding of requests in state A
            // Grant device 0 if r[0]==1
            if (r[0]) begin
                next_state = B;
                g = 3'b001; // grant device 0
            end
            else if (r[1]) begin
                next_state = C;
                g = 3'b010; // grant device 1
            end
            else if (r[2]) begin
                next_state = D;
                g = 3'b100; // grant device 2
            end
            else begin
                next_state = A;
                g = 3'b000;
            end
        end

        B: begin
            g = 3'b001; // grant device 0
            if (r[0])
                next_state = B; // stay in B as long as r0=1
            else
                next_state = A; // otherwise go to A
        end

        C: begin
            g = 3'b010; // grant device 1
            if (r[1])
                next_state = C; // stay in C as long as r1=1
            else
                next_state = A;
        end

        D: begin
            g = 3'b100; // grant device 2
            if (r[2])
                next_state = D; // stay in D as long as r2=1
            else
                next_state = A;
        end

        default: begin
            next_state = A;
            g = 3'b000;
        end
    endcase
end

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

endmodule