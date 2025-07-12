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

    reg [2:0] state, next_state;
    reg [1:0] y_counter;    // To count 2 cycles for y monitoring
    reg g_permanent;         // To track permanent g state

    // State transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            y_counter <= 2'b00;
            g_permanent <= 1'b0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;
            
            // Update y counter and g_permanent in state F
            if (state == F) begin
                if (!g_permanent) begin
                    y_counter <= y_counter + 1;
                    if (y) begin
                        g_permanent <= 1'b1;
                    end else if (y_counter == 2'b01) begin
                        g_permanent <= 1'b0;
                    end
                end
            end else begin
                y_counter <= 2'b00;
            end

            // Output f is only high in state B
            f <= (next_state == B);
            
            // Output g logic
            if (state == F || next_state == F) begin
                g <= 1'b1;
            end else if (!resetn) begin
                g <= 1'b0;
            end
            
            // Maintain g output based on permanent state
            if (g_permanent) begin
                g <= 1'b1;
            end else if (state == F && y_counter == 2'b01 && !y) begin
                g <= 1'b0;
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
            F: next_state = F;  // Permanent state
            default: next_state = A;
        endcase
    end

endmodule