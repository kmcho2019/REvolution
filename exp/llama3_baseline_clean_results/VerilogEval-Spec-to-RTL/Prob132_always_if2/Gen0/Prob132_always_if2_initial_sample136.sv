module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        if (cpu_overheated) begin
            shut_off_computer = 1'b1; // Computer should shut off when overheated
        end else begin
            shut_off_computer = 1'b0; // Default to not shutting off when not overheated
        end
    end

    always @(*) begin
        if (~arrived) begin
            keep_driving = ~gas_tank_empty; // Keep driving if not arrived and gas tank is not empty
        end else begin
            keep_driving = 1'b0; // Default to not driving if arrived
        end
    end

endmodule