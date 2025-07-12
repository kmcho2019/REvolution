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
    localparam B = 3'b001;  // f=1 for one cycle
    localparam C = 3'b010;  // First '1' detected
    localparam D = 3'b011;  // '1-0' detected
    localparam E = 3'b100;  // '1-0-1' detected (set g=1)
    localparam F = 3'b101;  // First cycle with g=1
    localparam G = 3'b110;  // Second cycle with g=1 or y=1 detected
    localparam H = 3'b111;  // y not detected, g=0 permanently

    reg [2:0] state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (state)
            A: begin
                f = 0;
                g = 0;
                next_state = resetn ? B : A;
            end
            B: begin
                f = 1;
                g = 0;
                next_state = C;
            end
            C: begin
                f = 0;
                g = 0;
                next_state = x ? D : C;
            end
            D: begin
                f = 0;
                g = 0;
                next_state = x ? E : C;
            end
            E: begin
                f = 0;
                g = 1;
                next_state = F;
            end
            F: begin
                f = 0;
                g = 1;
                if (y) begin
                    next_state = G;
                end else begin
                    next_state = G;
                end
            end
            G: begin
                f = 0;
                if (y) begin
                    g = 1;
                    next_state = G;
                end else begin
                    g = 0;
                    next_state = H;
                end
            end
            H: begin
                f = 0;
                g = 0;
                next_state = H;
            end
            default: begin
                f = 0;
                g = 0;
                next_state = A;
            end
        endcase
    end

endmodule