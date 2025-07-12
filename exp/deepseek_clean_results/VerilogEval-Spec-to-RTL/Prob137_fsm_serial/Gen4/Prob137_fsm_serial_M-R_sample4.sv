module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Binary state encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational next state logic
    wire [1:0] next_state = 
        (state == IDLE && in == 0) ? RECEIVE :
        (state == RECEIVE && bit_count == 3'd7) ? STOP :
        (state == STOP && in == 1) ? IDLE :
        (state == STOP && in == 0) ? WAIT :
        (state == WAIT && in == 1) ? IDLE :
        state;

    // Combinational done signal
    assign done = (state == STOP && in == 1);

    // Single sequential block
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            // Bit counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Shift register logic
            if (state == RECEIVE) begin
                shift_reg <= {in, shift_reg[7:1]}; // LSB first
            end
        end
    end

endmodule