module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// State encoding
localparam IDLE = 2'b00;
localparam LOAD = 2'b01;
localparam SHFT = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    if (areset)
        next_state = IDLE;
    else if (load)
        next_state = LOAD;
    else if (ena)
        next_state = SHFT;
    else
        next_state = IDLE;
end

// State register and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        q <= 4'b0;
    end else begin
        state <= next_state;
        case (next_state)
            LOAD: q <= data;
            SHFT: q <= {1'b0, q[3:1]};
            default: q <= q; // IDLE maintains value
        endcase
    end
end

endmodule