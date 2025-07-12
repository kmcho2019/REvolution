module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam [3:0] 
        IDLE   = 4'b0001,
        RECEIVE = 4'b0010,
        STOP    = 4'b0100,
        ERROR   = 4'b1000;

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    wire shift_en;
    wire cnt_done;

    // Terminal count signal
    assign cnt_done = (bit_count == 3'b111);
    
    // Shift enable signal
    assign shift_en = (state == RECEIVE);

    // Done signal generation (combinational)
    assign done = (state == STOP) & in;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    state <= ~in ? RECEIVE : IDLE;
                    bit_count <= 0;
                end
                
                RECEIVE: begin
                    if (cnt_done)
                        state <= STOP;
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    state <= in ? IDLE : ERROR;
                end
                
                ERROR: begin
                    state <= in ? IDLE : ERROR;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    // Data shift register
    always @(posedge clk) begin
        if (reset)
            data_reg <= 0;
        else if (shift_en)
            data_reg <= {in, data_reg[7:1]};  // LSB first
    end

endmodule