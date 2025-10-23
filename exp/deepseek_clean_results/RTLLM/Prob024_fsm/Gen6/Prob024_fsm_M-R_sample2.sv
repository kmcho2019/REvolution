module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// One-hot state encoding
localparam [4:0] IDLE   = 5'b00001;
localparam [4:0] S1     = 5'b00010;
localparam [4:0] S10    = 5'b00100;
localparam [4:0] S100   = 5'b01000;
localparam [4:0] S1001  = 5'b10000;

reg [4:0] current_state;
wire [4:0] next_state;

// Next state logic using continuous assignments
assign next_state[0] = (~IN & (current_state == IDLE)) | 
                       (~IN & (current_state == S100)) | 
                       (~IN & (current_state == S1001));

assign next_state[1] = (IN & (current_state == IDLE)) | 
                      (IN & (current_state == S1)) | 
                      (IN & (current_state == S1001));

assign next_state[2] = (~IN & (current_state == S1));

assign next_state[3] = (~IN & (current_state == S10));

assign next_state[4] = (IN & (current_state == S100));

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Output logic (registered to improve timing)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        MATCH <= 1'b0;
    end else begin
        MATCH <= (current_state == S1001) && IN;
    end
end

endmodule