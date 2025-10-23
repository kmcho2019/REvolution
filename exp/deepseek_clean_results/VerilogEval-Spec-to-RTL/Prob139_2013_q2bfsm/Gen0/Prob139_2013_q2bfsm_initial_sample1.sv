module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define states
    localparam A = 3'b000;  // Initial/reset state
    localparam B = 3'b001;  // f=1 pulse state
    localparam C = 3'b010;  // Waiting for first 1 in x sequence
    localparam D = 3'b011;  // Got first 1, waiting for 0
    localparam E = 3'b100;  // Got 1-0, waiting for final 1
    localparam F = 3'b101;  // g=1 state, monitoring y
    localparam G = 3'b110;  // g=0 state (failed y condition)

    reg [2:0] state, next_state;
    reg [1:0] y_counter;    // To count 2 cycles for y monitoring

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            y_counter <= 2'b00;
        end else begin
            state <= next_state;
            
            // Update y counter in state F
            if (state == F) begin
                y_counter <= y_counter + 1;
            end else begin
                y_counter <= 2'b00;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = resetn ? B : A;
            B: next_state = C;
            C: next_state = x ? D : C;
            D: next_state = x ? C : E;
            E: next_state = x ? F : C;
            F: begin
                if (y) next_state = F;  // y=1 detected, stay permanently
                else if (y_counter == 2'b01) next_state = G;  // 2 cycles elapsed
                else next_state = F;    // keep waiting
            end
            G: next_state = G;          // Permanent until reset
            default: next_state = A;
        endcase
    end

    // Output logic
    always @(*) begin
        f = (state == B);
        g = (state == F || state == G) ? (state == F) : 1'b0;
    end

endmodule