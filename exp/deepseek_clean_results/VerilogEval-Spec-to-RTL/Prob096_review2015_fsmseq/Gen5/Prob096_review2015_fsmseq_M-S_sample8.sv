module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] state;
    reg found;
    
    localparam [1:0]
        IDLE   = 2'b00,
        GOT1   = 2'b01,
        GOT11  = 2'b10;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            found <= 1'b0;
        end else if (!found) begin
            case (state)
                IDLE:  state <= data ? GOT1 : IDLE;
                GOT1:  state <= data ? GOT11 : IDLE;
                GOT11: begin
                    if (!data) state <= GOT11;  // Got 110, stay to check next bit
                    else found <= 1'b1;         // Got 1101
                end
            endcase
        end
    end

    assign start_shifting = found;

endmodule