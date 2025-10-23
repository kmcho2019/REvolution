module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [4:0]  Hours, // 5 bits for 0-23
    output reg [5:0]  Mins,
    output reg [5:0]  Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs  <= 6'd0;
        Mins  <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Next-state variables to reduce combinational logic depth
        reg [5:0] next_Secs;
        reg [5:0] next_Mins;
        reg [4:0] next_Hours;

        // Increment seconds with rollover
        next_Secs = (Secs == 6'd59) ? 6'd0 : Secs + 6'd1;

        // Increment minutes on seconds rollover
        next_Mins = (Secs == 6'd59) ?
                    ((Mins == 6'd59) ? 6'd0 : Mins + 6'd1) :
                    Mins;

        // Increment hours on minutes and seconds rollover
        next_Hours = (Secs == 6'd59 && Mins == 6'd59) ?
                     ((Hours == 5'd23) ? 5'd0 : Hours + 5'd1) :
                     Hours;

        // Update registers
        Secs  <= next_Secs;
        Mins  <= next_Mins;
        Hours <= next_Hours;
    end
end

endmodule