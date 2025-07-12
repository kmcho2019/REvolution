module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Gray-coded state definitions
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b11;
    localparam D = 2'b10;

    reg [1:0] state, next_state;

    // State transition logic with parallel case
    always @(*) begin
        next_state = A; // Default
        case (state) // synthesis parallel_case
            A: begin
                casez (r)
                    3'b1??: next_state = B;  // Priority to r[0]
                    3'b01?: next_state = C;   // Then r[1]
                    3'b001: next_state = D;  // Finally r[2]
                    default: next_state = A;
                endcase
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            g <= 3'b000;
        end else begin
            state <= next_state;
            // Registered output logic
            case (next_state)
                B: g <= 3'b001;
                C: g <= 3'b010;
                D: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end

endmodule