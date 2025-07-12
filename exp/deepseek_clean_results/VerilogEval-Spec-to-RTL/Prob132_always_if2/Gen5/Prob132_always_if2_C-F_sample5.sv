module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Computer control - unconditional assignment
        shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;
        
        // Driving logic - explicit combinational expression
        keep_driving = (~arrived) ? ~gas_tank_empty : 1'b0;
    end

endmodule