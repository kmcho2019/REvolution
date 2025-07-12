module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);
    typedef enum {HIGH, LOW} clk_state_t;
    clk_state_t state;
    reg [31:0] counter;
    
    initial begin
        clk = 1'b0;
        state = LOW;
        counter = 0;
    end

    always @(state or counter) begin
        case (state)
            HIGH: clk = 1'b1;
            LOW:  clk = 1'b0;
        endcase
    end

    always #1 begin
        counter <= counter + 1;
        
        case (state)
            HIGH: begin
                if (counter >= (PERIOD/2 - 1)) begin
                    state <= LOW;
                    counter <= 0;
                end
            end
            LOW: begin
                if (counter >= (PERIOD/2 - 1)) begin
                    state <= HIGH;
                    counter <= 0;
                end
            end
        endcase
    end
endmodule