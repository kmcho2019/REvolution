module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;
    reg [3:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        next_state = A;  // Default
        case (1'b1)  // Synopsys parallel_case
            state[A]: begin
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else next_state = A;
            end
            state[B]: next_state = r[0] ? B : A;
            state[C]: next_state = r[1] ? C : A;
            state[D]: next_state = r[2] ? D : A;
        endcase
    end

    // Sequential state register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            g <= 3'b000;
        end
        else begin
            state <= next_state;
            // Registered outputs
            g <= {next_state[D], next_state[C], next_state[B]};
        end
    end

endmodule