module barrel_shifter (
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output reg [7:0] out
);
    always @(*) begin
        // Start with input
        reg [7:0] temp;
        temp = in;
        
        // Rotate right by 4 if ctrl[2] set
        if (ctrl[2])
            temp = {temp[3:0], temp[7:4]};
        
        // Rotate right by 2 if ctrl[1] set
        if (ctrl[1])
            temp = {temp[1:0], temp[7:2]};
        
        // Rotate right by 1 if ctrl[0] set
        if (ctrl[0])
            temp = {temp[0], temp[7:1]};
        
        out = temp;
    end
endmodule