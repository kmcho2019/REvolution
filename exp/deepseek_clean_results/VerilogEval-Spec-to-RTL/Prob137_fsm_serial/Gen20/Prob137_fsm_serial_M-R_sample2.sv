module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam WAIT    = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    wire shift_en;

    // Continuous assignment for done signal
    assign done = (state == WAIT) && (in == 1'b1);

    // Shift enable condition
    assign shift_en = (state == RECEIVE);

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= RECEIVE;
                    end
                end
                
                RECEIVE: begin
                    if (bit_count == 3'b111) begin
                        state <= WAIT;
                    end
                end
                
                WAIT: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Bit counter logic
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'b0;
        end else if (state == RECEIVE) begin
            bit_count <= bit_count + 1;
        end else begin
            bit_count <= 3'b0;
        end
    end

    // Data shift logic
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (shift_en) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

endmodule