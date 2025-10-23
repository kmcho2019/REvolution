module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam IDLE   = 2'b00;
    localparam GOT1   = 2'b01;
    localparam GOT11  = 2'b10;
    localparam GOT110 = 2'b11;

    reg [1:0] state;
    reg [1:0] last_bits;  // Stores last 2 bits for efficient comparison

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            last_bits <= 2'b0;
        end else if (!start_shifting) begin
            // Update state and shift register
            case (state)
                IDLE: begin
                    last_bits <= {last_bits[0], data};
                    state <= data ? GOT1 : IDLE;
                end
                GOT1: begin
                    last_bits <= {last_bits[0], data};
                    state <= data ? GOT11 : IDLE;
                end
                GOT11: begin
                    last_bits <= {last_bits[0], data};
                    state <= data ? GOT11 : GOT110;
                end
                GOT110: begin
                    last_bits <= {last_bits[0], data};
                    state <= data ? IDLE : IDLE;  // Reset state if we find the pattern
                end
            endcase
        end
    end

    // Detect pattern when in GOT110 state and next bit is 1
    assign start_shifting = (state == GOT110) && data;

endmodule