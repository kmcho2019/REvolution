module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// State encoding
localparam RESET = 2'b00;
localparam LOAD  = 2'b01;
localparam SHIFT = 2'b10;
localparam HOLD  = 2'b11;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        RESET: next_state = areset ? RESET : (load ? LOAD : (ena ? SHIFT : HOLD));
        LOAD:  next_state = areset ? RESET : (load ? LOAD : (ena ? SHIFT : HOLD));
        SHIFT: next_state = areset ? RESET : (load ? LOAD : (ena ? SHIFT : HOLD));
        HOLD:  next_state = areset ? RESET : (load ? LOAD : (ena ? SHIFT : HOLD));
    endcase
end

// State register and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= RESET;
        q <= 4'b0;
    end
    else begin
        state <= next_state;
        case (next_state)
            LOAD:  q <= data;
            SHIFT: q <= {1'b0, q[3:1]};
            default: q <= q; // HOLD or RESET
        endcase
    end
end

endmodule