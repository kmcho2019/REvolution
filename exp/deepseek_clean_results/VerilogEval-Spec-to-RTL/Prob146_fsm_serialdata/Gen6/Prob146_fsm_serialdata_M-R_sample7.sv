module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot state encoding
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP   = 4'b0100;
    
    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    wire done_internal;

    // Combinational next state and output logic
    always @(*) begin
        case (state)
            IDLE:   next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
            STOP:   next_state = (in == 1'b1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
        end
    end

    // Combinational shift register
    always @(*) begin
        if (state == RECEIVE) begin
            shift_reg = {in, shift_reg[7:1]};
        end else begin
            shift_reg = shift_reg; // Hold value when not receiving
        end
    end

    // Output update only when done
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'b0;
        end else if (done_internal) begin
            out_byte <= shift_reg;
        end
    end

    // Combinational done signal
    assign done_internal = (state == STOP) && (in == 1'b1);
    assign done = done_internal;

endmodule