module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_shift <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (!in) state <= RECEIVE; // Start bit detected
                end
                
                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]}; // Shift in LSB first
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'b111) state <= STOP;
                end
                
                STOP: begin
                    if (in) state <= IDLE; // Valid stop bit
                    // Otherwise stay in STOP until we see stop bit
                end
            endcase
        end
    end

    // Done is high when we get valid stop bit
    assign done = (state == STOP) && in;

endmodule