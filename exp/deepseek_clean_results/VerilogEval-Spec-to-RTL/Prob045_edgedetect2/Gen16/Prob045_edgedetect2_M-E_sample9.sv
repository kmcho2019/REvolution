module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // State encoding
    localparam STABLE = 2'b00;
    localparam RISING = 2'b01;
    localparam FALLING = 2'b10;

    reg [1:0] state [0:7];  // 2-bit state for each of 8 bits
    reg [7:0] prev_in;

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            prev_in[i] <= in[i];
            
            case (state[i])
                STABLE: begin
                    if (prev_in[i] && !in[i]) begin
                        state[i] <= FALLING;
                    end
                    else if (!prev_in[i] && in[i]) begin
                        state[i] <= RISING;
                    end
                end
                RISING, FALLING: begin
                    state[i] <= STABLE;
                end
            endcase
            
            anyedge[i] <= (state[i] != STABLE);
        end
    end

    // Initialize all states to STABLE
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            state[i] = STABLE;
            anyedge[i] = 0;
            prev_in[i] = 0;
        end
    end

endmodule