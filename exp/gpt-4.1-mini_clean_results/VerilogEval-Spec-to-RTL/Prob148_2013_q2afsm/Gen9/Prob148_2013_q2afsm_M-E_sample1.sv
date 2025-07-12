module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot encoded states
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state and output logic combined
    always @(*) begin
        // Default values
        next_state = A;
        g = 3'b000;

        case (state)
            A: begin
                if (r[0]) begin
                    next_state = B;
                    g = 3'b001;
                end else if (r[1]) begin
                    next_state = C;
                    g = 3'b010;
                end else if (r[2]) begin
                    next_state = D;
                    g = 3'b100;
                end else begin
                    next_state = A;
                    g = 3'b000;
                end
            end

            B: begin
                g = 3'b001;
                if (r[0])
                    next_state = B;
                else
                    next_state = A;
            end

            C: begin
                g = 3'b010;
                if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end

            D: begin
                g = 3'b100;
                if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end

            default: begin
                next_state = A;
                g = 3'b000;
            end
        endcase
    end

endmodule