module TopModule (
    input         clk,
    input         resetn,
    input  [2:0]  r,
    output reg [2:0] g
);

    // State encoding (binary):
    // A = 2'b00 (idle)
    // B = 2'b01 (grant device 0)
    // C = 2'b10 (grant device 1)
    // D = 2'b11 (grant device 2)
    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00; // state A idle on reset
        else
            state <= next_state;
    end

    // Next-state logic and output logic combined in one combinational block
    always @(*) begin
        // Default assignments
        next_state = state;
        g = 3'b000;

        case(state)
            2'b00: begin // state A idle
                if (r[0]) begin
                    next_state = 2'b01; // B: grant device 0
                    g = 3'b001;
                end else if (r[1]) begin
                    next_state = 2'b10; // C: grant device 1
                    g = 3'b010;
                end else if (r[2]) begin
                    next_state = 2'b11; // D: grant device 2
                    g = 3'b100;
                end else begin
                    // remain idle, no grants
                    next_state = 2'b00;
                    g = 3'b000;
                end
            end

            2'b01: begin // state B: grant device 0
                if (r[0]) begin
                    next_state = 2'b01;
                    g = 3'b001;
                end else begin
                    next_state = 2'b00;
                    g = 3'b000;
                end
            end

            2'b10: begin // state C: grant device 1
                if (r[1]) begin
                    next_state = 2'b10;
                    g = 3'b010;
                end else begin
                    next_state = 2'b00;
                    g = 3'b000;
                end
            end

            2'b11: begin // state D: grant device 2
                if (r[2]) begin
                    next_state = 2'b11;
                    g = 3'b100;
                end else begin
                    next_state = 2'b00;
                    g = 3'b000;
                end
            end

            default: begin
                next_state = 2'b00;
                g = 3'b000;
            end
        endcase
    end

endmodule