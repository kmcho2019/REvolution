module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    typedef enum logic [1:0] {
        IDLE,    // Waiting for start bit
        RECEIVE, // Receiving 8 data bits
        STOP     // Checking stop bit
    } state_t;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin
                        state <= RECEIVE;
                        bit_count <= 0;
                    end
                end
                
                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]}; // LSB first
                    if (bit_count == 3'b111) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    if (in) begin
                        state <= IDLE;
                    end else begin
                        // Wait here until we get a valid stop bit
                        state <= STOP;
                    end
                end
            endcase
        end
    end

    assign done = (state == STOP) && in;

endmodule