module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg checking; // Flag to indicate if we are in the checking phase
reg [1:0] counter; // Counter for clock cycles in the checking phase
reg [1:0] w_count; // Counter for w = 1 in the checking phase

always @(posedge clk) begin
    if(reset) begin
        checking <= 0;
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end
    else begin
        if(!checking) begin
            if(s) begin
                checking <= 1;
                counter <= 1;
                w_count <= w? 1 : 0;
            end
        end
        else begin
            if(w) begin
                w_count <= w_count + 1;
            end
            counter <= counter + 1;
            if(counter == 3) begin
                z <= (w_count == 2)? 1 : 0;
                checking <= 0;
                counter <= 0;
                w_count <= 0;
            end
        end
    end
end

endmodule