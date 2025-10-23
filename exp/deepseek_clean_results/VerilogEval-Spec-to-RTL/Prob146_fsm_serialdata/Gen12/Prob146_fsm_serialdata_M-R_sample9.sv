module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // One-hot state encoding
    localparam IDLE   = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP   = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational next state logic
    wire [2:0] next_state;
    assign next_state = 
        (reset) ? IDLE :
        (state == IDLE) ? (in == 1'b0 ? RECEIVE : IDLE) :
        (state == RECEIVE) ? (bit_count == 3'b111 ? STOP : RECEIVE) :
        (state == STOP) ? (in == 1'b1 ? IDLE : STOP) :
        IDLE;

    // Combinational outputs
    assign out_byte = shift_reg;
    assign done = (state == STOP) & (in == 1'b1);

    // Sequential logic
    always @(posedge clk) begin
        state <= next_state;

        if (reset) begin
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
        end else begin
            case (next_state)
                IDLE: begin
                    bit_count <= 3'b0;
                end
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // Maintain shift_reg value
                    bit_count <= 3'b0;
                end
                default: begin
                    bit_count <= 3'b0;
                    shift_reg <= 8'b0;
                end
            endcase
        end
    end

endmodule