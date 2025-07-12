module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding - binary for area efficiency
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] current_state, next_state;
    reg [2:0] r_reg;  // Registered inputs for better timing

    // Register inputs to improve timing
    always @(posedge clk) begin
        if (!resetn) r_reg <= 3'b0;
        else r_reg <= r;
    end

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            g <= 3'b0;
        end
        else begin
            current_state <= next_state;
            
            // Output update only when state changes
            case (next_state)
                B: g <= 3'b001;
                C: g <= 3'b010;
                D: g <= 3'b100;
                default: g <= 3'b000;  // State A
            endcase
        end
    end

    // State transition logic - purely combinational
    always @(*) begin
        case (current_state)
            A: begin
                if (r_reg[0]) next_state = B;
                else if (r_reg[1]) next_state = C;
                else if (r_reg[2]) next_state = D;
                else next_state = A;
            end
            B: next_state = r_reg[0] ? B : A;
            C: next_state = r_reg[1] ? C : A;
            D: next_state = r_reg[2] ? D : A;
        endcase
    end

endmodule