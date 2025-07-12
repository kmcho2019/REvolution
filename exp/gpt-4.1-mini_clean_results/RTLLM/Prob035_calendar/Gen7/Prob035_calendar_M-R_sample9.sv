module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 fits in 5 bits
    output reg  [5:0] Mins,  // 0-59 fits in 6 bits
    output reg  [5:0] Secs   // 0-59 fits in 6 bits
);

localparam [5:0] SEC_MAX = 6'd59;
localparam [5:0] MIN_MAX = 6'd59;
localparam [4:0] HR_MAX  = 5'd23;

// Combinational calculation of next states
wire [5:0] next_Secs;
wire [5:0] next_Mins;
wire [4:0] next_Hours;

assign next_Secs = (Secs == SEC_MAX) ? 6'd0 : Secs + 6'd1;

assign next_Mins = (Secs == SEC_MAX) ?
                   ((Mins == MIN_MAX) ? 6'd0 : Mins + 6'd1) :
                   Mins;

assign next_Hours = (Secs == SEC_MAX && Mins == MIN_MAX) ?
                    ((Hours == HR_MAX) ? 5'd0 : Hours + 5'd1) :
                    Hours;

// Sequential logic to update registers
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs  <= 6'd0;
        Mins  <= 6'd0;
        Hours <= 5'd0;
    end else begin
        Secs  <= next_Secs;
        Mins  <= next_Mins;
        Hours <= next_Hours;
    end
end

endmodule